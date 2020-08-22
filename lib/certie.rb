
require 'openssl'

class CertificateWrapper
  @@subject_prefix = '/C=AE/ST=Dubai/L=Hamriya/O=Knight/OU=Engineering'
  # @@rootCa = nil
  # @@rootKey = nil

  def self.get_counter_next
    serial = 0
    if File.exists?('serial.txt')
      File.open 'serial.txt', 'r' do |myfile|
        strSerial = myfile.readline
        strSerial.chomp!
        serial = strSerial.to_i
      end
    else
      serial = 0
    end

    serial += 1

    File.open 'serial.txt', 'w' do |myfile|
      myfile.print serial.to_s
    end

    serial
  end

  def self.create_certificate(cn=nil)
    if cn.nil?
      cn = "ca"
    end

    subject = @@subject_prefix + '/CN=' + cn
    serial = get_counter_next

    key = OpenSSL::PKey::RSA.new 2048
    File.open "#{cn}.rsa", 'wb' do |myfile|
      myfile.print key.to_pem
    end

    cert = OpenSSL::X509::Certificate.new
    cert.version = 2 #This is v3

    cert.serial = serial

    cert.subject =  OpenSSL::X509::Name.parse subject
    cert.public_key = key.public_key
    cert.not_before = Time.now
    cert.not_after = cert.not_before + (60 * 60 * 24 * 365)

    ef = OpenSSL::X509::ExtensionFactory.new


    if cn == "ca"
      cert.issuer = OpenSSL::X509::Name.parse subject
      ef.subject_certificate = cert
      ef.issuer_certificate = cert
      cert.add_extension ef.create_extension('basicConstraints', 'CA:TRUE', true)
      cert.add_extension ef.create_extension('keyUsage', 'keyCertSign, cRLSign', true)
      cert.add_extension ef.create_extension('subjectKeyIdentifier', 'hash', false )
      cert.add_extension ef.create_extension('authorityKeyIdentifier', 'keyid:always', false)

      cert.sign key, OpenSSL::Digest.new('SHA256')

      File.open "#{cn}.cert", 'wb' do |myfile|
        myfile.print cert.to_pem
      end
    else
      rootCert = OpenSSL::X509::Certificate.new File.read 'ca.cert'
      rootKey = OpenSSL::PKey::RSA.new File.read 'ca.rsa'

      cert.issuer = OpenSSL::X509::Name.parse(@@subject_prefix + '/CN=' + 'ca')
      ef.subject_certificate = cert
      ef.issuer_certificate = rootCert
      # cert.add_extension ef.create_extension('keyUsage', 'digitalSignature', true)  # TODO: check if we can set webServer and webClient
      cert.add_extension ef.create_extension('subjectKeyIdentifier', 'hash', false )

      cert.sign rootKey, OpenSSL::Digest.new('SHA256')

      File.open "#{cn}.cert", 'wb' do |myfile|
        myfile.print cert.to_pem
      end
    end

    `openssl pkcs8 -topk8 -inform pem -in "#{cn}.rsa" -out "#{cn}.key" -nocrypt`
    `cat "#{cn}.cert" "#{cn}.key" > "#{cn}.pem"`
  end


  def self.build(cn)
    doWeHaveARootCertificate = File.exists? 'ca.cert'
    doWeHaveARootKey = File.exists? 'ca.rsa'

    if not (doWeHaveARootCertificate and doWeHaveARootKey)
      create_certificate
    end

    create_certificate cn
  end
end
