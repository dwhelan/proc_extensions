require 'sourcify'
require 'forwardable'

class ProcSource
  extend Forwardable

  def initialize(proc = nil, &block)
    if proc
      fail ArgumentError, 'cannot pass both an argument and a block' if block
      fail ArgumentError, 'argument must be a Proc'                  unless proc.is_a?(Proc)
    end

    @proc = proc || block
  end

  def ==(other)
    case
    when other.proc == proc
      true
    when other.arity != arity || other.lambda? != lambda?
      false
    else
      other.sexp == sexp
    end
  rescue Exception
    false
  end

  def match(other)
    self == other || source_equal(other)
  rescue Exception
    false
  end

  alias_method :=~, :match

  def raw_source
    extract_source(:to_raw_source)
  end

  def source
    extract_source(:to_source)
  end

  alias_method :to_s,    :source
  alias_method :inspect, :source

  protected

  attr_reader :proc

  def_delegators :proc, :arity, :lambda?
  def_delegators :sexp, :sexp_body, :count

  def sexp
    @sexp ||= proc.to_sexp
  end

  def parameters
    sexp[2].sexp_body.to_a
  end

  def source_equal(other)
    case
    when other.count != count || other.lambda? != lambda?
      false
    when other.sexp_body == sexp_body
      true
    else
      other.sexp == sexp_with_parameters_from(other)
    end
  end

  private

  def sexp_with_parameters_from(other_proc)
    new_sexp = sexp.sub(sexp[2], other_proc.sexp[2])
    other_proc.parameters.each_with_index do |to, index|
      from = parameters[index]
      new_sexp = new_sexp.gsub(s(:lvar, from), s(:lvar, to))
    end
    new_sexp
  end

  def extract_source(method)
    proc_source = proc.public_send(method)
    lambda? ? proc_source.sub('proc ', 'lambda ') : proc_source
  end
end
