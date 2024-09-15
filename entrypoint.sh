#!/usr/bin/env bash
set -eo pipefail
IFS=$'\n\t'

# adapted from https://github.com/addnab/docker-run-action/blob/main/entrypoint.sh

main() {
    local COLOR_RED="\e[0;31m"
    local COLOR_RESET="\e[0m"

    declare -A env_vars=(
        [HOME]=1 [CI]=1 [GITHUB_ACTIONS]=1 [GITHUB_WORKSPACE]=1 [GITHUB_EVENT_PATH]=1 [GITHUB_OUTPUT]=1
        [GITHUB_ENV]=1 [GITHUB_STATE]=1 [GITHUB_STEP_SUMMARY]=1 [GITHUB_PATH]=1
    )
    local script
    IFS=" " read -r -a argv <<< "$INPUT_OPTIONS"
    IFS=" " read -r -a run_args <<< "$INPUT_RUN_ARGS"

    # try to guard against both run and run_args being specified
    if [[ -n "$INPUT_RUN" ]] && [[ -n "$INPUT_RUN_ARGS" ]]; then
        echo -e "${COLOR_RED}error: run and run-args are mutually exclusive.${COLOR_RESET}"
    fi

    # pull the image
    if [[ -n "$INPUT_PLATFORM" ]]; then
        docker pull -q --platform "$INPUT_PLATFORM" "$INPUT_IMAGE"
    else
        docker pull -q "$INPUT_IMAGE"
    fi

    # set required parameters
    argv+=(--rm --workdir /github/workspace --entrypoint "$INPUT_SHELL")

    # set network
    if [[ -n "$INPUT_DOCKER_NETWORK" ]]; then
        argv+=(--network "$INPUT_DOCKER_NETWORK")
    fi

    # set the platform
    if [[ -n "$INPUT_PLATFORM" ]]; then
        argv+=(--platform "$INPUT_PLATFORM")
    fi

    # add important environment variables that mustn't be overriden
    argv+=(
        -e "HOME=/github/home"
        -e "CI=true"
        -e "GITHUB_ACTIONS=true"
        -e "GITHUB_WORKSPACE=/github/workspace"
        -e "GITHUB_EVENT_PATH=${GITHUB_EVENT_PATH/#$RUNNER_TEMP//github/workflow}"
        -e "GITHUB_OUTPUT=${GITHUB_OUTPUT/#$RUNNER_TEMP//github/file_commands}"
        -e "GITHUB_ENV=${GITHUB_ENV/#$RUNNER_TEMP//github/file_commands}"
        -e "GITHUB_STATE=${GITHUB_STATE/#$RUNNER_TEMP//github/file_commands}"
        -e "GITHUB_STEP_SUMMARY=${GITHUB_STEP_SUMMARY/#$RUNNER_TEMP//github/file_commands}"
        -e "GITHUB_PATH=${GITHUB_PATH/#$RUNNER_TEMP//github/file_commands}"
    )

    # load user set environment variables
    while IFS= read -r env; do
        # insert if it doesn't override important variables that can't be overriden
        if ! [[ -v env_vars["$env"] ]]; then
            argv+=(-e "$env")
            env_vars["$env"]=1
        fi
    done <<< "$(jq -r 'keys | .[]' <<< "$INPUT_ACTIONS_ENV")"

    # load GHA environment variables
    while IFS= read -r env; do
        # insert if it doesn't override important variables that can't be overriden
        if [[ "$env" = GITHUB_* ]] \
            || [[ "$env" = RUNNER_* ]] \
            || [[ "$env" = ACTIONS_* ]] \
            && ! [[ -v env_vars["$env"] ]]; then
            argv+=(-e "$env")
            env_vars["$env"]=1
        fi
    done <<< "$(env | grep -o "^[^=]*")"

    # add important volumes
    # some directories here are taken from action steps that uses docker:// protocols
    DOCKER_HOST="${DOCKER_HOST:-unix:///var/run/docker.sock}"
    DOCKER_HOST="${DOCKER_HOST#unix://}"
    argv+=(
        -v "$DOCKER_HOST:$DOCKER_HOST"
        -v "$RUNNER_TEMP/_github_home:/github/home"
        -v "$RUNNER_TEMP/_github_workflow:/github/workflow"
        -v "$RUNNER_TEMP/_runner_file_commands:/github/file_commands"
        -v "$GITHUB_WORKSPACE:/github/workspace"
    )

    # add user defined volumes
    while IFS= read -r line; do
        if [[ -n "${line// }" ]]; then
            argv+=('-v' "$line")
        fi
    done <<< "$INPUT_VOLUMES"

    # create the script file and mount it in the container
    if [[ -n "$INPUT_RUN" ]]; then
        script="$(mktemp -t script.sh.XXXXXX)"
        printf '%s' "$INPUT_RUN" > "$script"
        run_args=('--login' '-e' '-o' 'pipefail' '/script.sh')
        argv+=('-v' "$script:/script.sh:ro")
    fi

    exec docker run "${argv[@]}" "$INPUT_IMAGE" "${run_args[@]}"
}

main "$@"