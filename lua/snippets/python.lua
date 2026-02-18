local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

ls.add_snippets("python", {
  s("defm", { -- Сниппет для метода класса
    t("def "), i(1, "method_name"), t("(self"), i(2, ", arg1"), t(") -> "), i(3, "None"), t(":"),
    t({"", "\t"}), i(4, "pass")
  })
})
