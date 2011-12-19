#encoding: UTF-8
=begin
alias gbk_puts puts
def puts(*args)
  gbk_puts(*(args.collect{|item|item.encode "GBK", :invalid => :replace, :undef => :replace}))
end

def p(*args)
  print(args.collect{|item|item.inspect.encode "GBK", :invalid => :replace, :undef => :replace}.join("\n")+"\n") rescue print(args.join("\n")+"\n")
end
=end
def filesize_inspect(size)
  case size
  when 0...1024
    size.to_s + "B"
  when 1024...1024*1024
    (size/1024).to_s + "KB"
  else
    (size/1024/1024).to_s + "MB"
  end
end


require 'sdl'
include SDL
require 'yaml'
$config = YAML.load_file("config.yml") rescue YAML.load_file("data/config_default.yml")

SDL.init(INIT_VIDEO | INIT_AUDIO)
WM::set_caption("iDuel - 享受决斗", "graphics/system/iDuelPanel_32512.ico")
WM::icon = Surface.load("graphics/system/iDuelPanel_32512.ico")

style = HWSURFACE
style |= FULLSCREEN if $config["fullscreen"]
$screen = Screen.open($config["width"], $config["height"], 0, style)

TTF.init

Mixer.open(Mixer::DEFAULT_FREQUENCY,Mixer::DEFAULT_FORMAT,Mixer::DEFAULT_CHANNELS,512)
require_relative 'scene'
require_relative 'window'
require_relative 'window_list'
require_relative 'window_user'
require_relative 'scene_title'
require_relative 'fpstimer'
require_relative 'widget_msgbox'
require_relative 'game'
require_relative 'game_event'
require_relative 'cacheable'
require_relative 'user'
require_relative 'room'
#4.times{Thread.new{loop{sleep 0.01}}}

$fpstimer = FPSTimer.new
$scene = Scene_Title.new
begin
  $scene.main while $scene
#rescue
#  p $!, $!.backtrace
#  Widget_Msgbox.new("程序出错", "程序可能出现了一个bug，请去论坛反馈") { $scene = Scene_Title.new  }
#  retry
end