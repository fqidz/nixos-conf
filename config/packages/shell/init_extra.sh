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
    if [[ -z "$1" ]]; then
        echo "error: no first arg" > /dev/stderr
        return 1
    elif [[ -z "$2" ]]; then
        echo "error: no second arg" > /dev/stderr
        return 1
    fi

    if [[ "$1" == "init" ]]; then
        nix flake init --template github:fqidz/nix-templates#$2
    elif [[ "$1" == "new" ]]; then
        nix flake new --template github:fqidz/nix-templates#$2 $3
    else
        echo "error: 1st arg either 'init' or 'new'" > /dev/stderr
        return 1
    fi
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

    search_path=$(
        printf "%s\n" "$processed_data" | \
            fzf \
            -d '\t' \
            --with-nth 1 \
            --preview='echo {} | cut -f2' \
            --preview-window=up,1 | \
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
            firefox_exec="firefox"
            systemd-inhibit --why="Keep book open for reading" $firefox_exec --new-window "$file_path"
        else
            systemd-inhibit --why="Keep book open for reading" xdg-open "$file_path"
        fi
    fi
}
