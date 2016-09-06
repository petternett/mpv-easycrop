local msg = require('mp.msg')
local script_name = "easycrop"

local crop = function(p1, p2)
    -- Video native dimensions
    local vid_w = mp.get_property("width")
    local vid_h = mp.get_property("height")

    -- Screen size
    local osd_w = mp.get_property("osd-width")
    local osd_h = mp.get_property("osd-height")

    -- Factor by which the video is scaled to fit the screen
    local scale = math.min(osd_w/vid_w, osd_h/vid_h)

    -- Size video takes up in screen
    local vid_sw, vid_sh = scale*vid_w, scale*vid_h

    -- Video offset within screen
    local off_x = math.floor((osd_w - vid_sw)/2)
    local off_y = math.floor((osd_h - vid_sh)/2)

    -- Convert screen-space to video-space
    p1.x = math.floor((p1.x - off_x) / scale)
    p1.y = math.floor((p1.y - off_y) / scale)
    p2.x = math.floor((p2.x - off_x) / scale)
    p2.y = math.floor((p2.y - off_y) / scale)

    local w = math.abs(p1.x - p2.x)
    local h = math.abs(p1.y - p2.y)
    local x = math.min(p1.x, p2.x)
    local y = math.min(p1.y, p2.y)
    mp.command(string.format("vf add @%s:crop=%s:%s:%s:%s", easy_crop, w, h, x, y))
end

local file_loaded_cb = function ()
	local points = {}
    mp.add_key_binding("mouse_btn0", function ()
        local mx, my = mp.get_mouse_pos()
        table.insert(points, { x = mx, y = my })
        if #points == 2 then
            crop(points[1], points[2])
            points = {}
        end
    end)
end

mp.register_event('file-loaded', file_loaded_cb)
