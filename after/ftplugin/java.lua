-- Java language configs and JDTLS setup
local set = vim.opt_local

set.shiftwidth = 4
set.tabstop = 4
set.number = true
set.relativenumber = true

-- JDTLS (java lsp) serup
local jdtls = require("jdtls")

-- Path to JDTLS
local jdtls_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls"

-- Determine OS-specific config directory
local os_config = "linux"
if vim.fn.has("mac") == 1 then
  os_config = "mac"
elseif vim.fn.has("win32") == 1 then
  os_config = "win"
end

-- Create a unique workspace directory for each project
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. project_name

-- JDTLS configuration
local config = {
  cmd = {
    "java", -- Run the Java executable

    -- Eclipse/OSGi configuration
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",

    -- Logging settings
    "-Dlog.protocol=true", -- Log LSP protocol messages
    "-Dlog.level=ALL", -- Log everything (can change to WARN for less noise)

    -- JVM memory settings
    "-Xmx1g", -- Give JDTLS max 1GB of RAM

    -- Java 9+ module system settings
    "--add-modules=ALL-SYSTEM",
    "--add-opens",
    "java.base/java.util=ALL-UNNAMED",
    "--add-opens",
    "java.base/java.lang=ALL-UNNAMED",

    -- The actual JDTLS JAR to run
    "-jar",
    vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar"),

    -- Point to the OS-specific configuration
    "-configuration",
    jdtls_path .. "/config_" .. os_config,

    -- Where to store this project's workspace data
    "-data",
    workspace_dir,
  },

  -- How to find the project root
  root_dir = jdtls.setup.find_root({ ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }),

  -- Java-specific settings
  settings = {
    java = {
      signatureHelp = { enabled = true }, -- Show method signatures as you type
      contentProvider = { preferred = "fernflower" }, -- Decompiler for viewing library source
      completion = {
        favoriteStaticMembers = {
          "org.junit.jupiter.api.Assertions.*", -- Auto-import JUnit assertions
          "org.junit.Assert.*",
        },
      },
    },
  },

  -- Initialization options (for plugins like debugger)
  init_options = {
    bundles = {}, -- We'll add debugger bundles here later if needed
  },

  -- Start JDTLS or attach to existing instance
  jdtls.start_or_attach(config),
}
