
require 'openssl'

class CertificateWrapper
  @@subject_prefix = '/C=AE/ST=Dubai/L=Dubai/O=KNR/OU=Software'

  def self.load_subject_prefix
    filename = "#{Dir.home}/.certie_subjprefix"
    if File.exists?(filename)
      @@subject_prefix = File.read(filename).chomp
    else
      File.write(filename, @@subject_prefix)
    end
  end

  def self.file_cat(output_file, input_array)
    File.open output_file, 'w' do |outfile|
      input_array.each do |iter_infile|
        outfile.write(File.read(iter_infile))
        outfile.write "\n"
      end
    end
  end

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

    # TODO: Find an alternative to invoking OpenSSL and cat - OpenSSL v2.2.0 seems to have private_to_pem in OpenSSL::PKey
    `openssl pkcs8 -topk8 -inform pem -in "#{cn}.rsa" -out "#{cn}.key" -nocrypt`

    # TODO: Test replacement of the system call cat with file_cat
    # `cat "#{cn}.cert" "#{cn}.key" > "#{cn}.pem"`
    file_cat "#{cn}.pem", ["#{cn}.cert", "#{cn}.key"]
  end


  def self.build(cn)
    load_subject_prefix

    doWeHaveARootCertificate = File.exists? 'ca.cert'
    doWeHaveARootKey = File.exists? 'ca.rsa'

    # TODO: Handle the case where we have only one and not the other (cert and key)
    if not (doWeHaveARootCertificate and doWeHaveARootKey)
      create_certificate
    end

    create_certificate cn
  end
end

# key = OpenSSL::PKey::RSA.new 2048
# puts key.private_to_pem
