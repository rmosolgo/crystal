lib LibC
  fun mkstemp(result : Char*) : Int
end

class Tempfile < IO::FileDescriptor
  def initialize(name)
    if tmpdir = ENV["TMPDIR"]?
      tmpdir = tmpdir + File::SEPARATOR unless tmpdir.ends_with? File::SEPARATOR
    else
      tmpdir = "/tmp/"
    end
    @path = "#{tmpdir}#{name}.XXXXXX"
    super(LibC.mkstemp(@path), blocking: true)
  end

  getter path

  def self.open(filename)
    tempfile = Tempfile.new(filename)
    begin
      yield tempfile
    ensure
      tempfile.close
    end
    tempfile
  end

  def delete
    File.delete(@path)
  end

  def unlink
    delete
  end
end
