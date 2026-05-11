package com.financeiro.service;

import javax.mail.Message;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.mail.Authenticator;

import java.util.Properties;

public class EmailService {

    private static final String REMETENTE = "enzoboni120604@gmail.com";
    private static final String SENHA = "pzbo lcra sxty ywbx";

    public static void enviar(String destino, String assunto, String mensagem) {

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");

        Session session = Session.getInstance(props,
                new Authenticator() {
                    protected PasswordAuthentication getPasswordAuthentication() {
                        return new PasswordAuthentication(REMETENTE, SENHA);
                    }
                });

        try {
            Message msg = new MimeMessage(session);
            msg.setFrom(new InternetAddress(REMETENTE));
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(destino));
            msg.setSubject(assunto);
            msg.setText(mensagem);

            Transport.send(msg);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}