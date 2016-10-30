user_mail = 'bella21abyss@gmail.com'

# Install mailutils
sudo apt-get install -y mailutils
# config postfix
echo "inet_interfaces = loopback-only" >> /etc/postfix/main.cf
# restart postfix
sudo service postfix restart
# send test mail straight to you
echo "This is the body of the email" | mail -s "This is the subject line" user_mail
# config postfix to send mails come to smtp server redirect to you
echo "root:          sammy@example.com" >> /etc/aliases
# restart newaliass
sudo newaliases
# send test mail to smtp
echo "This is the body of the email" | mail -s "This is the subject line" root