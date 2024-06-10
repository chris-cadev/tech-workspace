function clean_path() {
    export PATH=`echo $PATH | sed -e "s/\:/\n/g" | sort | uniq | paste -s -d: -`
}