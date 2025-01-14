_mvn() 
{
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    GREP=`which grep`

    opts="-am|-amd|-B|-C|-c|-cpu|-D|-e|-emp|-ep|-f|-fae|-ff|-fn|-gs|-h|-l|-N|-npr|-npu|-nsu|-o|-P|-pl|-q|-rf|-s|-T|-t|-U|-up|-V|-v|-X"

    common_lifecycle_phases="clean|process-resources|compile|process-test-resources|test-compile|test|package|install|deploy|site"
    common_plugins="deploy|failsafe|install|site|surefire|checkstyle|javadoc|jxr|pmd|ant|antrun|archetype|assembly|dependency|enforcer|gpg|help|release|repository|source|eclipse|idea|jetty|cargo|jboss|tomcat|tomcat6|exec|versions|sonar|war|ear|ejb|hibernate3|android|scm"
    
    plugin_goals_deploy="deploy:deploy-file"
    plugin_goals_failsafe="failsafe:integration-test|failsafe:verify"
    plugin_goals_install="install:install-file"
    plugin_goals_site="site:site|site:deploy|site:run|site:stage|site:stage-deploy"
    plugin_goals_surefire="surefire:test"
    
    plugin_goals_checkstyle="checkstyle:checkstyle|checkstyle:check"
    plugin_goals_javadoc="javadoc:javadoc|javadoc:jar|javadoc:aggregate"
    plugin_goals_jxr="jxr:jxr"
    plugin_goals_pmd="pmd:pmd|pmd:cpd|pmd:check|pmd:cpd-check"

    plugin_goals_ant="ant:ant|ant:clean"
    plugin_goals_antrun="antrun:run"
    plugin_goals_archetype="archetype:generate|archetype:create-from-project|archetype:crawl"
    plugin_goals_assembly="assembly:single"
    plugin_goals_dependency="dependency:analyze|dependency:list|dependency:resolve|dependency:tree"
    plugin_goals_enforcer="enforcer:enforce"
    plugin_goals_gpg="gpg:sign|gpg:sign-and-deploy-file"
    plugin_goals_help="help:active-profiles|help:all-profiles|help:describe|help:effective-pom|help:effective-settings|help:evaluate|help:expressions|help:system"
    plugin_goals_release="release:clean|release:prepare|release:rollback|release:perform|release:stage|release:branch|release:update-versions"
    plugin_goals_repository="repository:bundle-create|repository:bundle-pack"
    plugin_goals_source="source:aggregate|source:jar|source:jar-no-fork"
    
    plugin_goals_eclipse="eclipse:clean|eclipse:eclipse"
    plugin_goals_idea="idea:clean|idea:idea"
    
    plugin_goals_jetty="jetty:run|jetty:run-exploded"
    plugin_goals_cargo="cargo:start|cargo:run|cargo:stop|cargo:deploy|cargo:undeploy|cargo:help"
    plugin_goals_jboss="jboss:start|jboss:stop|jboss:deploy|jboss:undeploy|jboss:redeploy"
    plugin_goals_tomcat="tomcat:start|tomcat:stop|tomcat:deploy|tomcat:undeploy"
    plugin_goals_tomcat6="tomcat6:run|tomcat6:stop|tomcat6:deploy|tomcat6:undeploy"
    plugin_goals_exec="exec:exec|exec:java"
    plugin_goals_versions="versions:display-dependency-updates|versions:display-plugin-updates|versions:display-property-updates|versions:update-parent|versions:update-properties|versions:update-child-modules|versions:lock-snapshots|versions:unlock-snapshots|versions:resolve-ranges|versions:set|versions:use-releases|versions:use-next-releases|versions:use-latest-releases|versions:use-next-snapshots|versions:use-latest-snapshots|versions:use-next-versions|versions:use-latest-versions|versions:commit|versions:revert"
    plugin_goals_sonar="sonar:sonar|sonar:help"
    plugin_goals_scm="scm:add|scm:checkin|scm:checkout|scm:update|scm:status"

    plugin_goals_war="war:war|war:exploded|war:inplace|war:manifest"
    plugin_goals_ear="ear:ear|ear:generate-application-xml"
    plugin_goals_ejb="ejb:ejb"
    plugin_goals_android="android:apk|android:apklib|android:deploy|android:deploy-dependencies|android:dex|android:emulator-start|android:emulator-stop|android:emulator-stop-all|android:generate-sources|android:help|android:instrument|android:manifest-update|android:pull|android:push|android:redeploy|android:run|android:undeploy|android:unpack|android:version-update|android:zipalign"

    plugin_goals_hibernate3="hibernate3:hbm2ddl|hibernate3:help"

    options="-Dmaven.test.skip=true|-DskipTests|-Dmaven.surefire.debug|-DenableCiProfile|-Dpmd.skip=true|-Dcheckstyle.skip=true"

    profile_settings=`[ -e ~/.m2/settings.xml ] && grep -e "<profile>" -A 1 ~/.m2/settings.xml | grep -e "<id>.*</id>" | sed 's/.*<id>/-P/' | sed 's/<\/id>//g'`
    profile_pom=`[ -e pom.xml ] && grep -e "<profile>" -A 1 pom.xml | grep -e "<id>.*</id>" | sed 's/.*<id>/-P/' | sed 's/<\/id>//g'`

    local IFS=$'|\n'

    if [[ ${cur} == -D* ]] ; then
      COMPREPLY=( $(compgen -S ' ' -W "${options}" -- ${cur}) )

    elif [[ ${cur} == -P* ]] ; then
      COMPREPLY=( $(compgen -S ' ' -W "${profile_settings}|${profile_pom}" -- ${cur}) )

    elif [[ ${cur} == -* ]] ; then
        COMPREPLY=( $(compgen -W "${opts}" -S ' ' -- ${cur}) )

    elif [[ ${prev} == -pl ]] ; then
        if [[ ${cur} == *,* ]] ; then
            COMPREPLY=( $(compgen -d -S ',' -P "${cur%,*}," -- ${cur##*,}) )
        else
            COMPREPLY=( $(compgen -d -S ',' -- ${cur}) )
        fi

    elif [[ ${cur} == *:* ]] ; then
        for plugin in $common_plugins; do
          if [[ ${cur} == ${plugin}:* ]]; then
            var_name="plugin_goals_${plugin}"
            COMPREPLY=( $(compgen -W "${!var_name}" -S ' ' -- ${cur}) )
          fi
        done

    else
        if echo "${common_lifecycle_phases}" | tr '|' '\n' | grep -q -e "^${cur}" ; then
          COMPREPLY=( $(compgen -S ' ' -W "${common_lifecycle_phases}" -- ${cur}) )
        elif echo "${common_plugins}" | tr '|' '\n' | grep -q -e "^${cur}"; then
          COMPREPLY=( $(compgen -S ':' -W "${common_plugins}" -- ${cur}) )
        fi
    fi
}

complete -o default -F _mvn -o nospace mvn
complete -o default -F _mvn -o nospace mvnDebug

COMP_WORDBREAKS=${COMP_WORDBREAKS//:}
