vim.opt_global.list = true
vim.opt_global.listchars = { tab = '▸ ', trail = '·', nbsp = '␣' }
vim.opt.number = true
vim.opt.switchbuf = "usetab,newtab"
vim.opt.mouse = "a"
vim.opt.tags = './tags,tags;' .. vim.fn.stdpath('cache') .. '/tags' -- Указываем путь к файлу тегов
