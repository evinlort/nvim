return {
  { "nvim-lua/plenary.nvim" },
  -- Telescope: поиск
  { "nvim-telescope/telescope.nvim",
    tag = "0.1.8",  -- Версия (Lua: tag string)
    dependencies = { "jmacadie/telescope-hierarchy.nvim" },
    cmd = { "Telescope", "AstGrep", "AstGrepSymbol", "AstGrepSymbolPrompt" },
    keys = {
      { "<leader><space>", "<cmd>Telescope find_files<CR>", desc = "Find files" },
      { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Live grep" },
      { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Buffers" },
      { "<leader>sa", "<cmd>AstGrepSymbol<CR>", desc = "AstGrep: search word under cursor" },
      { "<leader>si", "<cmd>Telescope hierarchy incoming_calls<CR>", desc = "LSP: search incoming calls" },
      { "<leader>so", "<cmd>Telescope hierarchy outgoing_calls<CR>", desc = "LSP: search outgoing calls" },
      { "<leader>sp", "<cmd>AstGrepSymbolPrompt<CR>", desc = "AstGrep: prompt from symbol under cursor" },
    },
    config = function()
      local actions = require("telescope.actions")
      local lsp_utils = require("core.lsp_server_utils")
      local telescope = require("telescope")

      local ast_grep_langs = {
        python = "python",
        lua = "lua",
        javascript = "javascript",
        javascriptreact = "tsx",
        typescript = "typescript",
        typescriptreact = "tsx",
        json = "json",
        yaml = "yaml",
        markdown = "markdown",
        bash = "bash",
        sh = "bash",
        go = "go",
        rust = "rust",
        c = "c",
        cpp = "cpp",
        java = "java",
      }

      local function notify(message, level)
        vim.notify(message, level or vim.log.levels.INFO, { title = "Search" })
      end

      local function ast_grep_lang()
        return ast_grep_langs[vim.bo.filetype]
      end

      local function ast_grep_root()
        return lsp_utils.resolve_root_dir(nil, 0) or vim.loop.cwd()
      end

      local function ast_grep_context()
        if vim.fn.exepath("ast-grep") == "" then
          notify("ast-grep CLI is not installed or not on PATH.", vim.log.levels.WARN)
          return nil
        end

        local lang = ast_grep_lang()
        if not lang then
          notify(string.format("AstGrep does not support filetype '%s' in this config.", vim.bo.filetype), vim.log.levels.WARN)
          return nil
        end

        return {
          lang = lang,
          root = ast_grep_root(),
        }
      end

      local function current_symbol()
        local symbol = vim.fn.expand("<cword>")
        if not symbol or symbol == "" then
          notify("No symbol under cursor.", vim.log.levels.WARN)
          return nil
        end
        return symbol
      end

      local function ast_grep_command(pattern, root, lang)
        return {
          "ast-grep",
          "run",
          "--pattern",
          pattern,
          "--lang",
          lang,
          "--json=stream",
          root,
        }
      end

      local function populate_quickfix(pattern, root, output)
        local items = {}
        for _, line in ipairs(vim.split(output or "", "\n", { trimempty = true })) do
          local ok, match = pcall(vim.json.decode, line)
          if ok and match and match.file and match.range and match.range.start then
            local filename = match.file
            if not filename:match("^/") then
              filename = vim.fs.joinpath(root, filename)
            end

            items[#items + 1] = {
              filename = vim.fs.normalize(filename),
              lnum = match.range.start.line + 1,
              col = match.range.start.column + 1,
              text = match.lines or match.text or pattern,
            }
          end
        end

        vim.fn.setqflist({}, "r", {
          title = string.format("ast-grep: %s", pattern),
          items = items,
        })

        if #items == 0 then
          notify(string.format('No ast-grep matches for "%s".', pattern), vim.log.levels.INFO)
          return
        end

        vim.cmd("copen")
      end

      local function run_ast_grep(pattern)
        if not pattern or pattern == "" then
          return
        end

        local context = ast_grep_context()
        if not context then
          return
        end

        vim.system(ast_grep_command(pattern, context.root, context.lang), { text = true }, function(result)
          vim.schedule(function()
            if result.code ~= 0 and result.code ~= 1 then
              notify(result.stderr ~= "" and result.stderr or "ast-grep failed.", vim.log.levels.ERROR)
              return
            end

            populate_quickfix(pattern, context.root, result.stdout)
          end)
        end)
      end

      local function ast_grep_prompt(opts)
        local provided = opts and opts.args or ""
        if provided ~= "" then
          run_ast_grep(provided)
          return
        end

        vim.ui.input({ prompt = "AstGrep pattern: " }, function(input)
          if not input or input == "" then
            return
          end
          run_ast_grep(input)
        end)
      end

      local function ast_grep_symbol()
        local symbol = current_symbol()
        if not symbol then
          return
        end
        run_ast_grep(symbol)
      end

      local function ast_grep_symbol_prompt()
        local symbol = current_symbol()
        if not symbol then
          return
        end

        vim.ui.input({
          prompt = "AstGrep pattern: ",
          default = symbol,
        }, function(input)
          if not input or input == "" then
            return
          end
          run_ast_grep(input)
        end)
      end

      telescope.setup({
        defaults = {
          mappings = {
            i = {
              ["<C-t>"] = actions.select_tab,  -- insert-mode
            },
            n = {
              ["<C-t>"] = actions.select_tab,  -- normal-mode в списке Telescope
            },
          },
        },
        extensions = {
          hierarchy = {
            layout_strategy = "horizontal",
          },
        },
      })
      telescope.load_extension("hierarchy")

      vim.api.nvim_create_user_command("AstGrep", ast_grep_prompt, {
        nargs = "*",
        desc = "Search project structure with ast-grep and send matches to quickfix",
      })
      vim.api.nvim_create_user_command("AstGrepSymbol", ast_grep_symbol, {
        desc = "Search ast-grep for the symbol under cursor",
      })
      vim.api.nvim_create_user_command("AstGrepSymbolPrompt", ast_grep_symbol_prompt, {
        desc = "Prompt with ast-grep pattern from the symbol under cursor",
      })
    end,
  },
}
