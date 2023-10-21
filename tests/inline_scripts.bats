# shellcheck disable=SC2317

load helper

@test 'step: setup-repo-codeartifact' {
	DATA_DIR=$(mktemp -d)
	export DATA_DIR

	GITHUB_ENV=$(mktemp)
	GITHUB_OUTPUT=$(mktemp)
	SCRIPT_DIR=$(mktemp -d)

	cat <../action.yaml |
		yq -r '.runs.steps | .[] | select(.id == "setup-repo-codeartifact") | .run' |
		sed 's/\${{ inputs.repo-aws-codeartifact }}/domain_owner\/domain\/repo/g' \
			>"$SCRIPT_DIR/script.sh"

	cat <"$SCRIPT_DIR/script.sh" >&3
	chmod +x "$SCRIPT_DIR/script.sh"

	__codeartifact_login() {
		while [ $# -gt 0 ]; do
			echo "$1" >>"$DATA_DIR/codeartifact_login"
			shift
		done
	}

	export -f __codeartifact_login

	aws() {
		command="$1"
		shift
		p1="$1"
		shift

		case "$command" in
		codeartifact)
			case "$p1" in
			login)
				__codeartifact_login "$@"
				;;
			get-authorization-token)
				echo 'TOKEN'
				;;
			esac
			;;
		*)
			echo >&3 "Invalid command $command"
			exit 1
			;;
		esac
	}

	export -f aws
	export GITHUB_OUTPUT
	export GITHUB_ENV

	run "$SCRIPT_DIR/script.sh"
	assert_success

	assert [ "$(cat <"$DATA_DIR/codeartifact_login" | sed "1q;d")" == '--tool' ]
	assert [ "$(cat <"$DATA_DIR/codeartifact_login" | sed "2q;d")" == 'pip' ]
	assert [ "$(cat <"$DATA_DIR/codeartifact_login" | sed "3q;d")" == '--domain-owner' ]
	assert [ "$(cat <"$DATA_DIR/codeartifact_login" | sed "4q;d")" == 'domain_owner' ]
	assert [ "$(cat <"$DATA_DIR/codeartifact_login" | sed "5q;d")" == '--domain' ]
	assert [ "$(cat <"$DATA_DIR/codeartifact_login" | sed "6q;d")" == 'domain' ]
	assert [ "$(cat <"$DATA_DIR/codeartifact_login" | sed "7q;d")" == '--repository' ]
	assert [ "$(cat <"$DATA_DIR/codeartifact_login" | sed "8q;d")" == 'repo' ]

	assert [ "$(cat <"$GITHUB_ENV" | grep 'POETRY_HTTP_BASIC_CODEARTIFACT_USERNAME' | cut -d '=' -f 2)" == 'aws' ]
	assert [ "$(cat <"$GITHUB_ENV" | grep 'POETRY_HTTP_BASIC_CODEARTIFACT_PASSWORD' | cut -d '=' -f 2)" == 'TOKEN' ]
}
