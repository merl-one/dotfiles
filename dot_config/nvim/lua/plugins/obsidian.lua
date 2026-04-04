return {
  "epwalsh/obsidian.nvim",
  version = "*",
  lazy = true,
  ft = "markdown",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    workspaces = {
      { name = "notes", path = "~/notes" },
    },
    daily_notes = {
      folder = "00-inbox",
      template = "daily-note.md",
    },
    templates = { folder = "templates" },
    ui = { enable = true },
  },
}
