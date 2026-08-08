package.path = "./?.lua;./?/init.lua;" .. package.path

local checks = 0
local function expect(condition, message)
    checks = checks + 1
    if not condition then error(message or ("check " .. checks .. " failed")) end
end

package.preload.logger = function()
    return { info = function() end, warn = function() end }
end
package.preload["one_reader.crypto"] = function()
    return { sha256_hex = function() return string.rep("a", 64) end }
end

local Updater = require("one_reader.updater")

expect(Updater.compare_versions("1.2.3", "1.2.2") == 1,
    "newer version was not detected")
expect(Updater.compare_versions("v1.2.3", "1.2.3") == 0,
    "v-prefixed version should compare equally")
expect(Updater.compare_versions("1.2.2", "1.2.3") == -1,
    "older version was not detected")
expect(Updater.compare_versions("invalid", "1.2.3") == nil,
    "invalid version should be rejected")

local direct_first = Updater.candidate_urls(Updater.API_URL, false)
expect(#direct_first == 4 and direct_first[1] == Updater.API_URL,
    "direct-first source order was wrong")
local proxy_first = Updater.candidate_urls(Updater.API_URL, true)
expect(#proxy_first == 4 and proxy_first[4] == Updater.API_URL,
    "proxy-first source order was wrong")
expect(#Updater.candidate_urls("https://example.com/update.zip", true) == 0,
    "untrusted update URL should be rejected")

local release, release_err = Updater.parse_release({
    tag_name = "0.5.0",
    draft = false,
    prerelease = false,
    body = "## Changes\n\n**Added** `OTA`",
    html_url = "https://github.com/finlater/one.koplugin/releases/tag/v0.5.0",
    assets = {
        {
            name = "one.koplugin-v0.5.0.zip",
            browser_download_url = "https://github.com/finlater/one.koplugin/releases/download/v0.5.0/one.koplugin-v0.5.0.zip",
            size = 1234,
        },
        {
            name = "one.koplugin-v0.5.0.zip.sha256",
            browser_download_url = "https://github.com/finlater/one.koplugin/releases/download/v0.5.0/one.koplugin-v0.5.0.zip.sha256",
        },
    },
})
expect(release ~= nil and release_err == nil, "valid release was rejected")
expect(release.version == "0.5.0" and release.archive_size == 1234,
    "release metadata was parsed incorrectly")
expect(release.notes:find("Added OTA", 1, true) ~= nil,
    "release notes were not normalized")

local missing, missing_err = Updater.parse_release({
    tag_name = "v0.5.0",
    assets = {},
})
expect(missing == nil and missing_err:find("checksum", 1, true),
    "release without checksum should be rejected")

local foreign = Updater.parse_release({
    tag_name = "v0.5.0",
    assets = {
        { name = "one.koplugin-v0.5.0.zip", browser_download_url = "https://example.com/plugin.zip" },
        { name = "one.koplugin-v0.5.0.zip.sha256", browser_download_url = "https://example.com/plugin.sha256" },
    },
})
expect(foreign == nil, "foreign download URL should be rejected")

package.loaded.json = {
    decode = function()
        return {
            tag_name = "0.4.3",
            assets = {},
            body = "Legacy release",
        }
    end,
}
local legacy_updater = Updater:new{
    settings = {
        get = function() return { prefer_proxy = false } end,
        set = function() end,
        flush = function() end,
    },
    current_version = "0.5.0",
    plugin_dir = "/tmp/one.koplugin",
}
function legacy_updater:_http_get_with_mirrors()
    return "{}"
end
local legacy_release, legacy_err = legacy_updater:fetch_release()
expect(legacy_release and legacy_release.version == "0.4.3" and not legacy_err,
    "an older asset-less release should still report up to date")

local meta = assert(io.open("_meta.lua", "r")):read("*a")
local main = assert(io.open("main.lua", "r")):read("*a")
local meta_version = meta:match('version%s*=%s*"([^"]+)"')
expect(main:find('version = PluginMeta.version', 1, true) ~= nil,
    "main.lua should use the metadata version")
expect(meta_version and meta_version:match("^%d+%.%d+%.%d+$") ~= nil,
    "metadata version should use X.Y.Z format")

print(("updater_spec: %d checks"):format(checks))
