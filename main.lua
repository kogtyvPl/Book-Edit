-- 
-- by: kogtyv
-- приложение создано мной
-- 
-- Импорт библиотек и переменные
local GUI = require("GUI")
local system = require("System")
local fs = require("Filesystem")

local scrol = {}
local lines = {""}
local textzg = ""
local codeView = ""
local cvhei = 40
local cvwid = 48
local stran = 1
---------------------------------------------------------------------------------

-- Создание 2-х окошек
local workspace, window, menu = system.addWindow(GUI.filledWindow(1, 1, 70, 25, 0xE1E1E1))
local workspace2, window2 = system.addWindow(GUI.filledWindow(65, 1, 50, 45, 0xCC9280))



-- Контейнеры. Разставление кнопок, полосок, ой короче всёй хуйни
local layout = window:addChild(GUI.layout(1, 12, 52, 30, 1, 1))
local textloy = window:addChild(GUI.layout(8, 2, 30, 4, 1, 1))
local inputloy = window:addChild(GUI.layout(16, 6, 48, 5, 1, 1))
local textinputl = window:addChild(GUI.layout(1, 6, 19, 5, 1, 1))
local buttonloy = window:addChild(GUI.layout(17, 11, 38, 14, 1, 1))
local textholst = window:addChild(GUI.layout(4, 15, 17, 6, 1, 1))
local strelka1 = window:addChild(GUI.layout(55, 2, 5, 3, 1, 1))
local strelka2 = window:addChild(GUI.layout(60, 2, 5, 3, 1, 1))
local textnstrel = window:addChild(GUI.layout(51, 1, 16, 3, 1, 1))
local layout2 = window2:addChild(GUI.layout(1, 1, window2.width, window2.height, 1, 1))

-- Приведствие твоей папочки
textloy:addChild(GUI.text(1, 1, 0x4B4B4B, "Привет, " .. system.getUser()))
textloy:addChild(GUI.text(1, 1, 0x4B4B4B, "Напиши свой роман! "))

-- Наименование строк
textinputl:addChild(GUI.text(1, 1, 0x4B4B4B, "Имя книги: "))
textinputl:addChild(GUI.text(1, 1, 0x4B4B4B, "Твой текст: "))

-- функции кнопочек и стрелочек
local function addButton2(text2)
return layout2:addChild(GUI.roundedButton(1, 1, 30, 1, 0xD2D2D2, 0x696969, 0x4B4B4B, 0xF0F0F0, text2))
end

local function addButton(text)
return buttonloy:addChild(GUI.roundedButton(1, 1, 30, 1, 0xD2D2D2, 0x696969, 0x4B4B4B, 0xF0F0F0, text))
end

local function str1(textstr1)
return strelka1:addChild(GUI.roundedButton(1, 1, 3, 1, 0xD2D2D2, 0x696969, 0x4B4B4B, 0xF0F0F0, textstr1))
end

local function str2(textstr2)
return strelka2:addChild(GUI.roundedButton(1, 1, 3, 1, 0xD2D2D2, 0x696969, 0x4B4B4B, 0xF0F0F0, textstr2))
end

local namefile = inputloy:addChild(GUI.input(15, 21, 48, 1, 0xEEEEEE, 0x555555, 0x999999, 0xFFFFFF, 0x2D2D2D, "MyBook", "Имя книги"))

-- номер страницы
local coustr = textnstrel:addChild(GUI.text(1, 1, 0x4B4B4B, "Cтраница: " .. stran))


-- стрелочки
str1("<").onTouch = function()
  if stran < 2 then
    GUI.alert("нельзя создать страницу ниже 1!")
  else
    stran = stran - 1
    coustr:remove()
    local coustr = textnstrel:addChild(GUI.text(1, 1, 0x4B4B4B, "Cтраница: " .. stran))
  end
end
str2(">").onTouch = function()
  stran = stran + 1
  fs.append("/Books/" .. namefile.text .. ".app/" .. stran .. ".txt", "")
  fs.copy("/Applications/Book Edit.app/Icons/Icon.pic", "/Books/" .. namefile.text .. ".app/Icon.pic")
  coustr:remove()
  local coustr = textnstrel:addChild(GUI.text(1, 1, 0x4B4B4B, "Cтраница: " .. stran))
  if stran > 128 then
    stran = stran - 1
    GUI.alert("Вы не можете создать больше 128-и страниц!")
  else
  --fs.append("/notepad/" .. namefile.text, " " .. lable.text)
  end
end




-- Окошко, где будет отображатся текст
local codeView = layout2:addChild(GUI.codeView(2, 2, 0, 0, 1, 1, 1, scrol, {}, GUI.LUA_SYNTAX_PATTERNS, GUI.LUA_SYNTAX_COLOR_SCHEME, true, lines))

-- действия кнопок и прочей хуйни которая меня не ебёт
local lable = inputloy:addChild(GUI.input(15, 15, 48, 1, 0xEEEEEE, 0x555555, 0x999999, 0xFFFFFF, 0x2D2D2D, textzg, "Напишите сюда текст"))
addButton("Записать изменения.txt").onTouch = function()
  if #lable.text > 0 then
    --GUI.alert(lable.text, " - этот текст был сохранён в файл")
    fs.append("/Books/" .. namefile.text .. ".app/" .. stran .. ".txt", "\n" .. lable.text)
    fs.copy("/Applications/Book Edit.app/Icons/Icon.pic", "/Books/" .. namefile.text .. ".app/Icon.pic")
    codeView:remove()
    local codeView = layout2:addChild(GUI.codeView(2, 2, cvwid, cvhei, 1, 1, 1, scrol, {}, GUI.LUA_SYNTAX_PATTERNS, GUI.LUA_SYNTAX_COLOR_SCHEME, true, {}))
    local counter = 4
    for line in require("filesystem").lines("/Books/" .. namefile.text .. ".app/" .. stran .. ".txt") do
      line = line:gsub("\t", "  "):gsub("\r\n", "\n")
      codeView.maximumLineLength = math.max(4, unicode.len(line)) --codeView.maximumLineLength, unicode.len(line))
      table.insert(codeView.lines, line) -- codeView.lines,

      counter = counter + 1
      if counter > codeView.height then
        break
      end
    end
  else
    GUI.alert("Пустая строка.")
  end
end
addButton("Загрузить файл.txt").onTouch = function()
  if #namefile.text > 0 then
    codeView:remove()
    local codeView = layout2:addChild(GUI.codeView(2, 2, cvwid, cvhei, 1, 1, 1, scrol, {}, GUI.LUA_SYNTAX_PATTERNS, GUI.LUA_SYNTAX_COLOR_SCHEME, true, {}))
    local counter = 1
    for line in require("filesystem").lines("/Books/" .. namefile.text .. ".app/" .. stran .. ".txt") do
  -- Replace tab symbols to 2 whitespaces and Windows line endings to UNIX line endings
      line = line:gsub("\t", "  "):gsub("\r\n", "\n")
      codeView.maximumLineLength = math.max(codeView.maximumLineLength, unicode.len(line))
      table.insert(codeView.lines, line)

      counter = counter + 1
      if counter > codeView.height then
        break
      end
    end
  else
    GUI.alert("Ошибка! Вы не можете загрузить не существующий файл!!!")
  end
end
addButton("Очистить страницу").onTouch = function()
  fs.remove("/Books/" .. namefile.text .. ".app/" .. stran .. ".txt")
  GUI.alert("Файл /Books/" .. namefile.text .. " удалён успешно.")
end
-- Размер холста (бесполезная хуитень которую надо заминить на другую хуитень)
textholst:addChild(GUI.text(1, 1, 0x4B4B4B, "Размер холста:"))
addButton("24x12").onTouch = function()
  cvhei = 12
  cvwid = 24 
end
addButton("45x24").onTouch = function()
  cvhei = 24
  cvwid = 45
end
addButton("48x40").onTouch = function()
  cvhei = 40
  cvwid = 48
end
addButton("100x40 - не удобен!").onTouch = function()
  cvhei = 40
  cvwid = 100
end
layout2:addChild(GUI.text(1, 1, 0x4B4B4B, "Отображение страницы"))



-- Верхнее управление окном
local contextMenu = menu:addContextMenuItem("File")
contextMenu:addItem("Новый")
contextMenu:addSeparator()
contextMenu:addItem("Сохранить как")
contextMenu:addItem("Save", true)
contextMenu:addItem("Открыть").onTouch = function()
  local filesystemDialog = GUI.addFilesystemDialog(workspace, false, 50, math.floor(workspace.height * 0.8), "Open", "Cancel", "File name", "/")
  filesystemDialog:setMode(GUI.IO_MODE_OPEN, GUI.IO_MODE_FILE)
  filesystemDialog:addExtensionFilter(".txt")
  filesystemDialog.onSubmit = function(path)
    GUI.alert("This path was selected: " .. path)
  end
  
  
  filesystemDialog:show()
end
contextMenu:addSeparator()
contextMenu:addItem("Закрыть").onTouch = function()
  window:remove()
end

-- Пояснение жизни!
menu:addItem("Использование").onTouch = function()
  GUI.alert("Здравствуйте, пишите здесь свои романы, сколько добыли ресурсов и что душа пожелает =)")
end

-- Чё-то Игор Темофеев писал за хуйню тут.
window.onResize = function(newWidth, newHeight)
  window.backgroundPanel.width, window.backgroundPanel.height = newWidth, newHeight
  layout.width, layout.height = newWidth, newHeight
end

window2.onResize = function(newWidth, newHeight)
  window2.backgroundPanel.width, window2.backgroundPanel.height = newWidth, newHeight
  layout.width, layout.height = newWidth, newHeight
end

---------------------------------------------------------------------------------

-- И дураку понятно что тут.
workspace:draw()
