FROM ev3dev/ev3dev-jessie-ev3-generic

COPY setup_jade.sh /root/
RUN chmod 766 /root/setup_jade.sh 
RUN /root/setup_jade.sh



