#!/bin/bash
# 请在这里编辑你的机器人命令

# This file is public domain in the USA and all free countries.
# Elsewhere, consider it to be WTFPLv2. (wtfpl.net/txt/copying)

# 初雪（hatsuyuki280）修改版，目前暂时定位为进行一些基础的汉化
# 并进行少许操作上的优化（如果可能的话）
# 更新地址请访问： https://github.com/topkecleon/telegram-bot-bash
# 增加部分注释

if [ "$1" = "source" ];then
	# 请将token扔进“token”文件
	TOKEN=$(cat token)
	# 将INLINE设置为1以接收内嵌查询。
	# 要在您的机器人中启用此选项，请将/ setinline命令发送到@BotFather。
	INLINE=0
	# 设置为 .* 以允许从任意位置发送文件
	FILE_REGEX='/home/user/allowed/.*'
else
	if ! tmux ls | grep -v send | grep -q $copname; then
		[ ! -z ${URLS[*]} ] && {
			curl -s ${URLS[*]} -o $NAME
			send_file "${CHAT[ID]}" "$NAME" "$CAPTION"
			rm "$NAME"
		}
		[ ! -z ${LOCATION[*]} ] && send_location "${CHAT[ID]}" "${LOCATION[LATITUDE]}" "${LOCATION[LONGITUDE]}"

		# Inline
		if [ $INLINE == 1 ]; then
			# inline query data
			iUSER[FIRST_NAME]=$(echo "$res" | sed 's/^.*\(first_name.*\)/\1/g' | cut -d '"' -f3 | tail -1)
			iUSER[LAST_NAME]=$(echo "$res" | sed 's/^.*\(last_name.*\)/\1/g' | cut -d '"' -f3)
			iUSER[USERNAME]=$(echo "$res" | sed 's/^.*\(username.*\)/\1/g' | cut -d '"' -f3 | tail -1)
			iQUERY_ID=$(echo "$res" | sed 's/^.*\(inline_query.*\)/\1/g' | cut -d '"' -f5 | tail -1)
			iQUERY_MSG=$(echo "$res" | sed 's/^.*\(inline_query.*\)/\1/g' | cut -d '"' -f5 | tail -6 | head -1)

			# Inline examples
			if [[ $iQUERY_MSG == photo ]]; then
				answer_inline_query "$iQUERY_ID" "photo" "http://blog.techhysahil.com/wp-content/uploads/2016/01/Bash_Scripting.jpeg" "http://blog.techhysahil.com/wp-content/uploads/2016/01/Bash_Scripting.jpeg"
			fi

			if [[ $iQUERY_MSG == sticker ]]; then
				answer_inline_query "$iQUERY_ID" "cached_sticker" "BQADBAAD_QEAAiSFLwABWSYyiuj-g4AC"
			fi

			if [[ $iQUERY_MSG == gif ]]; then
				answer_inline_query "$iQUERY_ID" "cached_gif" "BQADBAADIwYAAmwsDAABlIia56QGP0YC"
			fi
			if [[ $iQUERY_MSG == web ]]; then
				answer_inline_query "$iQUERY_ID" "article" "GitHub" "http://github.com/topkecleon/telegram-bot-bash"
			fi
		fi &
	fi
	case $MESSAGE in
		'/question')
			startproc "./question"
			;;
		'/info')
			send_markdown_message "${CHAT[ID]}" "This is bashbot, the *Telegram* bot written entirely in *bash*."
			;;
		'/start')
			send_action "${CHAT[ID]}" "typing"
			send_markdown_message "${CHAT[ID]}" "This is bashbot, the Telegram bot written entirely in bash.
It features background tasks and interactive chats, and can serve as an interface for CLI programs.
It currently can send, recieve and forward messages, custom keyboards, photos, audio, voice, documents, locations and video files.
*Available commands*:
*• /start*: _启动bot并收到这条消息_.
*• /info*: _Get shorter info message about this bot_.
*• /question*: _Start interactive chat_.
*• /cancel*: _Cancel any currently running interactive chats_.
*• /kickme*: _You will be autokicked from the chat_.
*• /leavechat*: _The bot will leave the group with this command _.
Written by Drew (@topkecleon) and Daniil Gentili (@danogentili).
Get the code in my [GitHub](http://github.com/topkecleon/telegram-bot-bash)
"
			;;
			
		'/leavechat')
			send_markdown_message "${CHAT[ID]}" "*LEAVING CHAT...*"
   			leave_chat "${CHAT[ID]}"
     			;;
     			
     		'/kickme')
     			kick_chat_member "${CHAT[ID]}" "${USER[ID]}"
     			unban_chat_member "${CHAT[ID]}" "${USER[ID]}"
     			;;
     			
		'/cancel')
			if tmux ls | grep -q $copname; then killproc && send_message "${CHAT[ID]}" "Command canceled.";else send_message "${CHAT[ID]}" "No command is currently running.";fi
			;;
		*)
			if tmux ls | grep -v send | grep -q $copname;then inproc; else send_message "${CHAT[ID]}" "$MESSAGE" "safe";fi
			;;
	esac
fi
