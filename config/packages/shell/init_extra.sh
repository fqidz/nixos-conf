bindkey '^ ' autosuggest-accept
bindkey '^k' up-line-or-history
bindkey '^j' down-line-or-history

typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[arg0]='fg=magenta,bold'
TIMEFMT=$'\nCPU\t%P\nuser\t%*U\nsystem\t%*S\ntotal\t%*E'

function fehv() {
  feh "$@" > /dev/null &!
}

function nix-templ {
    usage_string="Usage: nix-templ [init|new] [c|java|rust|...]"
    if [[ -z "$1" ]]; then
        echo "$usage_string"> /dev/stderr
        return 1
    elif [[ -z "$2" ]]; then
        echo "$usage_string" > /dev/stderr
        return 1
    fi

    if [[ "$1" == "init" ]]; then
        nix flake init --template github:fqidz/nix-templates#$2
    elif [[ "$1" == "new" ]]; then
        nix flake new --template github:fqidz/nix-templates#$2 $3
    else
        echo "ERROR: unknown \"$1\"" > /dev/stderr
        echo "$usage_string" > /dev/stderr
        return 1
    fi
}

function y {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

function _cleanup_ub {
    ueberzugpp cmd -s "$UEBERZUGPP_SOCKET" -a exit
}

function books {
    BOOKS_PATH="$HOME/Books/"

    data=$(
        sqlite3 \
            "${BOOKS_PATH}metadata.db" \
            "SELECT json_object('title', books.title, 'path', books.path) FROM books"
    )

    processed_data=$(while IFS='\n' read -r line; do
        title=$(printf "%s\n" "$line" | jq -rcs '.[].title')
        path=$(printf "%s\n" "$line" | jq -rcs '.[].path')
        printf "%s\t%s%s\n" "$title" "$BOOKS_PATH" "$path"
    done <<< "$data")

    trap _cleanup_ub HUP INT QUIT TERM EXIT

    UB_PID_FILE="/tmp/.$(uuidgen)"
    ueberzugpp layer --no-stdin --silent --use-escape-codes --pid-file "$UB_PID_FILE"
    UB_PID=$(cat "$UB_PID_FILE")

    export UEBERZUGPP_SOCKET=/tmp/ueberzugpp-"$UB_PID".socket

    search_path=$(
        # Moved into a variable to replace with nixpkgs path
        fzf_exec="fzf"
        printf "%s\n" "$processed_data" | \
            $fzf_exec \
            -d '\t' \
            --with-nth 1 \
            --border rounded \
            --padding 5% \
            --color="bg:-1" \
            --preview="ueberzugpp cmd \
                    -s $UEBERZUGPP_SOCKET \
                    -i fzfpreview \
                    -a add \
                    --xpos \$FZF_PREVIEW_LEFT \
                    --ypos \$FZF_PREVIEW_TOP \
                    --max-width \$FZF_PREVIEW_COLUMNS \
                    --max-height \$FZF_PREVIEW_LINES \
                    --file {2}/cover.jpg" \
            --preview-window left,border-block | \
            cut -f2
    )

    BLUE=$(tput setaf 4)
    UNDERLINE=$(tput smul)
    MAGENTA=$(tput setaf 5)
    NORMAL=$(tput sgr0)

    if [[ "$search_path" != "" ]]; then
        file_path=$(fd . "$search_path" -E'*.jpg' -E'*.opf')
        xdg_file_type=$(xdg-mime query filetype "$file_path")
        program_used=$(xdg-mime query default "$xdg_file_type")

        printf \
            "Opening %s with %s\n" \
            "\"${UNDERLINE}${BLUE}$(basename "$file_path")${NORMAL}\"" \
            "\"${UNDERLINE}${MAGENTA}"$program_used"${NORMAL}\""

        if [[ "$program_used" == "firefox.desktop" ]]; then
            # Moved into a variable to replace with nixpkgs path
            firefox_exec="firefox"
            $firefox_exec --new-window "$file_path"
        else
            xdg-open "$file_path"
        fi
    fi

    _cleanup_ub
}
