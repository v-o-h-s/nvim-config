local ascii_dir = vim.fn.stdpath("config") .. "/ascii"
local files = vim.fn.readdir(ascii_dir)

local arts = {}
for _, f in ipairs(files) do
  if f:match("%.txt$") then
    table.insert(arts, ascii_dir .. "/" .. f)
  end
end

math.randomseed(os.time())
local chosen = arts[math.random(#arts)]
local lines = vim.fn.readfile(chosen)

return table.concat(lines, "\n")
