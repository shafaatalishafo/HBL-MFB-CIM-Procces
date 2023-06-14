import random
from email.mime.text import MIMEText
from email.parser import HeaderParser
from email.mime.multipart import MIMEMultipart
import smtplib
import configparser

class changeexistingrole:
    
    def get_value_from_config_file(self, file, data, name=None):
        parser = configparser.ConfigParser(interpolation=None)
        parser.read(file)
        val = parser.get(data,name)
        return val
    
    def generate_random_password(self):
        Password = [
            'HblMFB@123',
            'MFB@Hbl123',
            'HblMF@123B',
            'MFB123@Hbl',
            'HBL@123mFB',
            'HblMB@123F',
            '123@HblMFB',
            'MFBHbl@123',
            'HBL123@MfB',
            '@HblMFB123',
            'MFBHbl123@',
            'MFB@123hbl',
            '321HblMFB@',
            '123HblMFB@',
            'MFB123Hbl@',
            'HBLMFb@123',
            '@123MFbHBL',
            'HBL@MFb123',
            'Hbl123@MFB',
            'mFB@HBL123',
            '@MFBHbl123',
            'HbL123MFB@',
            'Hbl@123MFB',
            'MFBHbl@321',
            '@MfB123HBL'
        ]

        random_password = random.choice(Password)
        print(random_password)
        return random_password
    
    def send_email(self, email_subject, email_body):
        #, user, ser, por, rec, ccr
        email_body = 'Hi Team,\n\n' + email_body + '\n\nThanks & Regards\n\n'
        
        # smtp_server = ser       #'192.168.241.62'  # Replace with your SMTP server address
        # smtp_port = por    #'25'  # Replace with the appropriate SMTP port
        # user_email = user    #       'rpa@hblmfb.com'  # Replace with your sender email address
        # receiver_email = [rec]  #  'awais.anjum@hblmfb.com' Replace with the recipient email address
        # cc = [ccr]        #'fahmeed.shaukat@hblmfb.com'
        
        user_email = 'rpa@hblmfb.com'
        send_email_protocol = '192.168.241.62'
        send_email_port = '25'
        email_receiver = 'cim@hblmfb.com'
        cc_receiver =  'fahmeed.shaukat@hblmfb.com'
        print(cc_receiver)
        email_receiver = email_receiver.split(',')
        if cc_receiver == "nan":
            cc_receiver = []
        else:
            cc_receiver = cc_receiver.split(",")
            print(cc_receiver)
        send_message = MIMEMultipart()
        send_message['From'] = user_email
        send_message['To'] = ', '.join(email_receiver)
        send_message['Cc'] = ', '.join(cc_receiver)
        send_message['Subject'] = email_subject
        send_message.attach(MIMEText(email_body, 'plain'))
        try:
            smtp_session = smtplib.SMTP(send_email_protocol, send_email_port)
            smtp_session.starttls()
            email_body = send_message.as_string()
            all_email_receivers = email_receiver+cc_receiver
            # smtp_session.sendmail(user_email, all_email_receivers, email_body)
            # smtp_session.quit()
            print('Send Email Successfully to ', str(all_email_receivers))
        except Exception as e:
            print(str(e))
            print('Acknowledgement not sent')