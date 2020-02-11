local args = {...}

if #args ~= 2 then
    print('usage: dl <url> <filename>')
    return
end

local req = http.get(args[1])
local res = req.readAll()
req.close()

local f = fs.open(args[2], 'w')
f.write(res)
f.close()

print('download complete')
