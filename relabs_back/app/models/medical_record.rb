require 'pg'
require_relative '../../db/database_connection'

class MedicalRecord
  def self.all
    begin
      @conn = DatabaseConnection.new
      medical_records = patient_records_head
      @conn.close
      medical_records
    rescue PG::Error => e
      []
    end
  end

  private

  def self.patient_records_head
    build_patient_record_grouped
    p_records_head = []

    @records_grouped_by_token.each do |token_resultado_exame, records|
      patient_data = records[0].slice("token_resultado_exame",
                                      "data_exame",
                                      "cpf",
                                      "nome_paciente",
                                      "email_paciente",
                                      "data_nascimento_paciente",
                                      "endereco_rua_paciente",
                                      "cidade_paciente",
                                      "estado_patiente")
      patient_data["doctor"] = records[0].slice("crm_medico", "crm_medico_estado", "nome_medico")
      patient_data["tests"] = @patient_record_tests[token_resultado_exame]
      p_records_head << patient_data
    end

    p_records_head
  end

  def self.build_patient_record_grouped
    @records_grouped_by_token = raw_medical_records.group_by { |record| record["token_resultado_exame"] }
    @patient_record_tests = {}

    @records_grouped_by_token.each do |token_resultado_exame, records|
      cleaned_records = records.map do |record|
        record.slice("tipo_exame", "limites_tipo_exame", "resultado_tipo_exame")
      end
      @patient_record_tests[token_resultado_exame] = cleaned_records
    end
  end

  def self.raw_medical_records
    query_result = @conn.exec('SELECT * FROM medical_record')
    query_result.map do |record|
      Hash[query_result.fields.zip(record.values)]
    end
  end

  def self.all_names
    all.map { |mr| mr['nome_paciente'] }
  end
end
