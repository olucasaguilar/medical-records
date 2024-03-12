require 'pg'
require_relative '../../db/database_connection'

class MedicalRecord
  attr_reader :token_resultado_exame, :tipo_exame, :limites_tipo_exame, :resultado_tipo_exame,
              :data_exame, :cpf, :nome_paciente, :email_paciente, :data_nascimento_paciente,
              :endereco_rua_paciente, :cidade_paciente, :estado_patiente, :doctor

  def initialize(data)
    @token_resultado_exame = data["token_resultado_exame"]
    @tipo_exame = data["tipo_exame"]
    @limites_tipo_exame = data["limites_tipo_exame"]
    @resultado_tipo_exame = data["resultado_tipo_exame"]
    @data_exame = data["data_exame"]
    @cpf = data["cpf"]
    @nome_paciente = data["nome_paciente"]
    @email_paciente = data["email_paciente"]
    @data_nascimento_paciente = data["data_nascimento_paciente"]
    @endereco_rua_paciente = data["endereco_rua_paciente"]
    @cidade_paciente = data["cidade_paciente"]
    @estado_patiente = data["estado_patiente"]
    @doctor = {
      crm_medico: data["crm_medico"],
      crm_medico_estado: data["crm_medico_estado"],
      nome_medico: data["nome_medico"]
    }
    @tests = data["tests"]
  end

  def to_json(*_args)
    {
      token_resultado_exame: @token_resultado_exame,
      tipo_exame: @tipo_exame,
      limites_tipo_exame: @limites_tipo_exame,
      resultado_tipo_exame: @resultado_tipo_exame,
      data_exame: @data_exame,
      cpf: @cpf,
      nome_paciente: @nome_paciente,
      email_paciente: @email_paciente,
      data_nascimento_paciente: @data_nascimento_paciente,
      endereco_rua_paciente: @endereco_rua_paciente,
      cidade_paciente: @cidade_paciente,
      estado_patiente: @estado_patiente,
      doctor: @doctor,
      tests: @tests
    }.to_json
  end

  def self.all
    begin
      @conn = DatabaseConnection.new
      raw_records = get_raw_records
      @conn.close
      grouped_records(raw_records)
    rescue PG::Error => e
      []
    end
  end

  private

  def self.get_raw_records
    query_result = @conn.exec('SELECT * FROM medical_record')
    query_result.map do |record|
      Hash[query_result.fields.zip(record.values)]
    end
  end

  def self.grouped_records(raw_records)
    grouped_records = raw_records.group_by { |record| record["token_resultado_exame"] }
    grouped_records.map do |token, records|
      tests = records.map do |record|
        {
          tipo_exame: record["tipo_exame"],
          limites_tipo_exame: record["limites_tipo_exame"],
          resultado_tipo_exame: record["resultado_tipo_exame"]
        }
      end
      data = records.first
      data["tests"] = tests
      MedicalRecord.new(data)
    end
  end

  def self.all_names
    all.map { |record| record.nome_paciente }
  end
end

