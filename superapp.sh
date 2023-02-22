#!/bin/bash





######################
#        FUNC        #
######################
func() {
    ansible-playbook -i hosts playbooks/$playbook
}
###----------------###





######################
#        HELP        #
######################
help() {
    echo ""
    echo "Usage: 'sudo bash $0 [option] {1|2|3}'"
    echo ""
    echo " 1    -   Playbook for install strongswan vpn"
    echo " 2    -   Playbook for create new user to strongswan vpn (with option: -n)"
    echo " 3    -   Playbook for deploy python telegram bot (with options: -t -i)"
    echo ""
    echo "  Options:"
    echo "  -n  -   Name of the new user to use strongswan vpn"
    echo "  -t  -   Telegram token for using bot"
    echo "  -i  -   ID of your profile telegram for bot administration"
    echo ""
}
###----------------###





######################
#        CASE        #
######################
if [ ! -f hosts ]; then
    echo ""
    echo "Before start this script, please use: 'sudo bash basicsetup.sh'"
    echo ""
    exit
fi
if [ -z "$1" ]; then
    echo ""
    echo "Empty list of options"
    echo "Use: 'sudo bash $0 -h'"
    echo ""
    exit
fi
while getopts ":h:n:t:i:" optionName; do
    case "$optionName" in
        h)
            help
            ;;
        n)
            new_user="$OPTARG"
            ;;
        t)
            telegram_token="$OPTARG"
            ;;
        i)
            id_profile_admin="$OPTARG"
            ;;
    esac
done
shift $((OPTIND-1))
###----------------###





######################
#        MAIN        #
######################
case "$1" in
    1)
        playbook="strongswan.yml"
        func
        ;;
    2)
        if  [ -z "$new_user" ]; then
            echo "Enter params new_user with -n"
            exit
        fi
        playbook="create_user_to_strongswan.yml -e new_user=$new_user"
        func
        ;;
    3)
        if  [ -z "$telegram_token" ]; then
            echo "Enter params telegram_token with -t"
            exit
        fi
        if  [ -z "$id_profile_admin" ]; then
            echo "Enter params id_profile_admin with -i"
            exit
        fi
        playbook="deploy_telegram_bot.yml -e telegram_token=$telegram_token -e id_profile_admin=$id_profile_admin"
        func
        ;;
    *)
        help
        ;;
esac
###----------------###