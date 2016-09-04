-- Users must be added manually.
-- Lower number = higher permissions
local users = { "1_Kuenstlah", "1_Phil", "1_Pascal", "2_Silvan", "2_Rrobi", "2_Sascha", "2_Dom", "2_Kat" }

function has_value (tab, val)
    for index, value in ipairs (tab) do
        if value == val then
            return true
        end
    end

    return false
end

function on_msg_receive (msg)
	if started == 0 then
		return
	end
	if msg.out then
		return
	end
	------ Nachricht als gelesen markieren
	if msg.text then
		mark_read (msg.from.print_name, ok_cb, false)
	end
	-----------------------
	if (has_value (users, msg.from.print_name)) then
		os.execute (string.format("/home/pi/tg/scripts/msg-parser.sh \"%s\" \"%s\" &", msg.text,msg.from.print_name))
	else
		os.execute (string.format("/home/pi/tg/scripts/sendmsg.sh \"%s\" \"Sorry, I don't know you. Please contact my boss!\" &",msg.from.print_name))
	end
os.execute (string.format("echo '%s;%s' >> /var/log/telegram.lua.log",msg.from.print_name,msg.text))

end

function on_our_id (id)
end

function on_secret_chat_created (peer)
end

function on_user_update (user)
end

function on_chat_update (user)
end

function on_get_difference_end ()
end

function on_binlog_replay_end ()
end
