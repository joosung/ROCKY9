#!/usr/bin/env bash

#####################################################################################
#                                                                                   #
# * APMinstaller with Rocky9 Linux                                                  #
# * ROCKY Linux-9.x                                                                 #
# * Apache 2.4.X , MariaDB 10.5.X, Multi-PHP(base php7.4) setup shell script        #
# * Created Date    : 2023/2/5                                                      #
# * Created by  : Joo Sung ( webmaster@apachezone.com )                             #
#                                                                                   #
#####################################################################################

echo "
 =======================================================

               < ROCKY AAI 설치 하기>

 =======================================================
"
echo "설치 하시겠습니까? 'Y' or 'N'"
read YN
YN=`echo $YN | tr "a-z" "A-Z"`
 
if [ "$YN" != "Y" ]
then
    echo "설치 중단."
    exit
fi

echo""
echo "설치를 시작 합니다."

cd /root/ROCKY9/APM

chmod 700 APMinstaller.sh

chmod 700 /root/ROCKY9/adduser.sh

chmod 700 /root/ROCKY9/deluser.sh

chmod 700 /root/ROCKY9/restart.sh

sh APMinstaller.sh

cd /root/ROCKY9

echo ""
echo ""
echo "ROCKY 설치 완료!"
echo ""
echo ""
echo ""

echo "
 =======================================================

               < phpMyAdmin 설치 하기>

 =======================================================
"
echo "phpMyAdmin 설치 하시겠습니까? 'Y' or 'N'"
read YN
YN=`echo $YN | tr "a-z" "A-Z"`
 
if [ "$YN" != "Y" ]
then
    echo "설치 중단."
    exit
fi

echo""
echo "phpMyAdmin 설치를 시작 합니다."
cd /root/ROCKY9/APM

chmod 700 phpMyAdmin.sh

sh phpMyAdmin.sh

echo ""
echo ""
echo "phpMyAdmin 설치 완료!"
echo ""
echo ""
echo ""

#설치 파일 삭제
rm -rf /root/ROCKY9/APM
echo ""
rm -rf /root/ROCKY9/install.sh
echo ""
exit;

esac

