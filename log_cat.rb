# http://developer.android.com/tools/debugging/debugging-log.html
# V — Verbose (lowest priority)
# D — Debug
# I — Info
# W — Warning
# E — Error
# F — Fatal
# S — Silent (highest priority, on which nothing is ever printed)

class LogCat
  C_RESET = "\e[0m"
  C_ERROR = "\e[0;31m"
  C_FATAL = "\e[1;31m"
  C_INFO  = "\e[0;32m"
  C_WARN  = "\e[0;33m"
  C_DEBUG = "\e[0;34m"
  C_VERBOSE = "\e[0;30m"
  C_UNKNOWN = "\e[1;30m"

  TAG_COLUMN_WIDHT = 30

  ALLOWED = %w(f e w i d v)

  def initialize
    @prev_tag = nil
  end

  def f(txt)
    colorize(txt, C_FATAL)
  end

  def e(txt)
    colorize(txt, C_ERROR)
  end

  def w(txt)
    colorize(txt, C_WARN)
  end

  def i(txt)
    colorize(txt, C_INFO)
  end

  def d(txt)
    colorize(txt, C_DEBUG)
  end

  def v(txt)
    colorize(txt, C_VERBOSE)
  end

  def s(txt)
    #silent
  end

  def reset(txt = "")
    colorize(txt, C_RESET)
  end

  def unknown(txt)
    colorize(txt, C_UNKNOWN)
  end

  #TODO this method still needs to be improved
  def process_line(line)
    result = line.match(/([VDIWEFS]{1})\/(.+)?\(\s*(\d+?)\)\:(.*)/)

    if result
      mode = result[1].downcase
      tag = result[2]
      msg = result[4]

      if ALLOWED.include?(mode)
        out = ""
        sep = ":"
        if @prev_tag == tag
          tag = ""
          sep = " "
        else
          @prev_tag = tag
        end

        out = "%c %+#{ TAG_COLUMN_WIDHT }s %c %s" % [mode, tag.strip, sep, msg]
        send(mode, out)
      end
    else
      unknown line
    end
  end

  private

  def colorize(txt, color)
    puts "#{color}#{txt}"
    print C_RESET
  end

end
