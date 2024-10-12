local module = {
  name = 'hints',
  desc = 'shows keymap hints when typing',
  plugins = {
    { 'echasnovski/mini.clue', version = false },
  },
}

local triggers = {
  { mode = 'n', keys = '<leader>' },
  { mode = 'n', keys = '<c-w>' },
  -- marks
  { mode = 'n', keys = "'" },
  { mode = 'n', keys = '`' },
  { mode = 'x', keys = "'" },
  { mode = 'x', keys = '`' },
  -- registers
  { mode = 'n', keys = '"' },
  { mode = 'x', keys = '"' },
  { mode = 'i', keys = '<c-r>' },
  { mode = 'c', keys = '<c-r>' },
  -- folds
  { mode = 'n', keys = 'z' },
  { mode = 'x', keys = 'z' },
}

local function generate_clues ()
  local miniclue = require'mini.clue'
  local clues = {
    miniclue.gen_clues.marks(),
    miniclue.gen_clues.registers(),
    miniclue.gen_clues.windows(),
    miniclue.gen_clues.z(),
  }
  for _, definition in pairs(_G.__prefixes__) do
    table.insert(clues, {
      mode = 'n',
      keys = definition[1],
      desc = definition.desc,
    })
  end
  for _, definition in pairs(_G.__keymaps__) do
    for _, mode in ipairs(definition.mode) do
      table.insert(clues, {
        mode = mode,
        keys = definition[1],
        desc = definition.desc,
      })
    end
  end
  return clues
end

module.fn = function ()
  require'mini.clue'.setup{
    triggers = triggers,
    clues = generate_clues(),
    window = {
      config = {
        width = 'auto',
      },
      width = 120,
      delay = 200,
    },
  }
end

return module

