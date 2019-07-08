#!/usr/bin/env sh
#
# unofficial dracula theme
set -g mouse on
set -g status-bg "colour59"
set -g message-command-fg "colour117"
set -g status-justify "left"
set -g status-left-length "100"
set -g status "on"
set -g pane-active-border-fg "colour215"
set -g message-bg "colour59"
set -g status-right-length "100"
set -g status-right-attr "none"
set -g message-fg "colour117"
set -g message-command-bg "colour59"
set -g status-attr "none"
set -g pane-border-fg "colour59"
set -g status-left-attr "none"
setw -g window-status-fg "colour231"
setw -g window-status-attr "none"
setw -g window-status-activity-bg "colour59"
setw -g window-status-activity-attr "none"
setw -g window-status-activity-fg "colour215"
setw -g window-status-separator ""
setw -g window-status-bg "colour59"
set -g status-left "#[fg=colour17,bg=colour215] #S #[fg=colour215,bg=colour59,nobold,nounderscore,noitalics]"
set -g status-right "#[fg=colour61,bg=colour59,nobold,nounderscore,noitalics]#[fg=colour231,bg=colour61] %Y-%m-%d | %H:%M #[fg=colour141,bg=colour61,nobold,nounderscore,noitalics]#[fg=colour17,bg=colour141] #h "
setw -g window-status-format "#[fg=colour231,bg=colour59] #I |#[fg=colour231,bg=colour59] #W "
setw -g window-status-current-format "#[fg=colour59,bg=colour59,nobold,nounderscore,noitalics]#[fg=colour117,bg=colour59] #I |#[fg=colour117,bg=colour59] #W #[fg=colour59,bg=colour59,nobold,nounderscore,noitalics]"

# binds
unbind C-b
set-option -g prefix \`
bind-key -n \` send-prefix
