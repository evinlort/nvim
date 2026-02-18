return {
  -- Statusline
  { "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local function navic_location()
        local ok, navic = pcall(require, "nvim-navic")
        if ok and navic.is_available() then
          return navic.get_location()
        end
        return ""
      end

      local function navic_available()
        local ok, navic = pcall(require, "nvim-navic")
        return ok and navic.is_available()
      end

      require("lualine").setup({
        sections = {
          lualine_c = {
            { navic_location, cond = navic_available },
            {
              "filename",
              path = 1,
            },
          },
        },
      })
    end,
  },
}
