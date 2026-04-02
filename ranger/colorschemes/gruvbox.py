from ranger.gui.colorscheme import ColorScheme
from ranger.gui.color import *

# Gruvbox palette (256-color approximations)
GB_BG0 = 235       # #282828
GB_BG1 = 237       # #3c3836
GB_BG2 = 239       # #504945
GB_FG0 = 223       # #ebdbb2
GB_FG1 = 223       # #ebdbb2
GB_RED = 167        # #fb4934
GB_GREEN = 142      # #b8bb26
GB_YELLOW = 214     # #fabd2f
GB_BLUE = 109       # #83a598
GB_PURPLE = 175     # #d3869b
GB_AQUA = 108       # #8ec07c
GB_ORANGE = 208     # #fe8019
GB_GRAY = 245       # #928374

class Default(ColorScheme):
    def use(self, context):
        fg, bg, attr = default_colors

        if context.reset:
            return default_colors

        elif context.in_browser:
            if context.selected:
                fg = GB_FG0
                attr = bold
                bg = GB_BG2
            else:
                attr = normal
                fg = GB_FG0
            if context.empty or context.error:
                fg = GB_RED
            if context.border:
                attr = normal
                fg = GB_GRAY
            if context.media:
                if context.image:
                    fg = GB_PURPLE
                else:
                    fg = GB_ORANGE
            if context.container:
                fg = GB_AQUA
            if context.directory:
                attr |= bold
                fg = GB_BLUE
            elif context.executable and not \
                    any((context.media, context.container,
                        context.fifo, context.socket)):
                attr |= bold
                fg = GB_GREEN
            if context.socket:
                fg = GB_PURPLE
                attr |= bold
            if context.fifo or context.device:
                fg = GB_YELLOW
                if context.device:
                    attr |= bold
            if context.link:
                fg = context.good and GB_AQUA or GB_RED
            if context.tag_marker and not context.selected:
                attr |= bold
                fg = GB_ORANGE
            if not context.selected and (context.cut or context.copied):
                fg = GB_GRAY
                attr |= bold
            if context.main_column:
                if context.selected:
                    attr |= normal
                if context.marked:
                    attr |= underline
                    fg = GB_YELLOW
            if context.badinfo:
                if attr & reverse:
                    bg = GB_RED
                else:
                    fg = GB_RED

        elif context.in_titlebar:
            attr |= normal
            fg = GB_FG0
            if context.hostname:
                fg = GB_RED if context.bad else GB_AQUA
            elif context.directory:
                fg = GB_BLUE
            elif context.tab:
                if context.good:
                    bg = GB_BG2
                    fg = GB_FG0
                else:
                    fg = GB_GRAY
            elif context.link:
                fg = GB_AQUA

        elif context.in_statusbar:
            fg = GB_FG0
            if context.permissions:
                if context.good:
                    fg = GB_GREEN
                elif context.bad:
                    fg = GB_RED
            if context.marked:
                attr |= bold | reverse
                fg = GB_YELLOW
            if context.frozen:
                fg = GB_AQUA
            if context.message:
                if context.bad:
                    attr |= bold
                    fg = GB_RED
            if context.loaded:
                bg = GB_BG2
            if context.vcsinfo:
                fg = GB_BLUE
                attr &= ~bold
            if context.vcscommit:
                fg = GB_YELLOW
                attr &= ~bold

        if context.text:
            if context.highlight:
                attr |= bold

        if context.in_taskview:
            if context.title:
                fg = GB_YELLOW

            if context.selected:
                attr |= normal

        return fg, bg, attr
