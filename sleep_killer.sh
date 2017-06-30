#It is used to kill processlist of MySQL sleep
#!/bin/sh
CONN="mysqladmin -h127.0.0.1 -P3306 -uadmin -pyoupassword"
while :
do
    n=`$CONN processlist | grep -i sleep |wc -l`
    date=`date +%Y%m%d\[%H:%M:%S]`
    echo $n
    thread_ids=""
    counter=0
    #最大连接数 800
    if [ "$n" -gt 800 ]; then
        #sleep time > 300
        for i in `$CONN processlist|grep -i sleep |awk '{if($12>300) print $2}'`; do
            if [ $counter -eq 0 ];then
	        thread_ids=$i
	    else
	        thread_ids=$thread_ids,$i
	    fi
	    let counter=counter+1

	    if [ "$counter" -eq  50 ];then
                echo "reach [$counter]:$thread_ids"
                $CONN kill $thread_ids
                thread_ids=""
                counter=0
	    fi
        done
        echo "end [$counter]:$thread_ids"
        if [ "$thread_ids" != "" ]
        then
            $CONN kill $thread_ids
        fi
        echo "$date : $n"
    fi               
    sleep 300
done