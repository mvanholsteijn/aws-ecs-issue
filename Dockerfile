FROM ubuntu
ADD doit.sh /
ENTRYPOINT [ "/doit.sh" ]
CMD [ "Hello", "ECS" ]
