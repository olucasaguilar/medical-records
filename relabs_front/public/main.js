function submitForm() {
  var form = document.getElementById('form');
  var formData = new FormData(form);

  fetch(form.action, {
    method: form.method,
    body: formData
  });

  const existingCards = document.querySelectorAll('.card');
  existingCards.forEach(card => card.remove());
  form.reset();
  fetchAndRenderData();
}

function fetchAndRenderData() {
  const fragment = new DocumentFragment();
  const url = 'http://localhost:3001/tests';

  fetch(url).
    then((response) => response.json()).
    then((data) => {
      data.forEach(function (record, index) {
        const recordElement = createRecordElement(record, index);
        fragment.appendChild(recordElement);
      });
    }).
    then(() => {
      document.body.appendChild(fragment);
    }).
    catch((error) => {
      console.log(error);
    });
}

function createRecordElement(record, index) {
  const div = document.createElement('div');
  div.className = 'card';

  const indexElement = document.createElement('div');
  indexElement.className = 'card-index';
  indexElement.textContent = 'nº' + (index + 1);
  indexElement.style.float = 'right';
  indexElement.style.fontSize = '14px';
  indexElement.style.fontWeight = 'bold';
  div.appendChild(indexElement);

  const examDataHeading = document.createElement('h2');
  examDataHeading.textContent = 'Dados do Exame';
  div.appendChild(examDataHeading);

  const examDataList = document.createElement('ul');
  examDataList.innerHTML = `
    <li><strong>Data:</strong> ${record.data_exame}</li>
    <li><strong>Token do Resultado:</strong> ${record.token_resultado_exame}</li>
  `;
  div.appendChild(examDataList);

  const patientDataHeading = document.createElement('h2');
  patientDataHeading.textContent = 'Dados do Paciente';
  div.appendChild(patientDataHeading);

  const patientDataList = document.createElement('ul');
  patientDataList.innerHTML = `
    <li><strong>Nome:</strong> ${record.nome_paciente}</li>
    <li><strong>CPF:</strong> ${record.cpf}</li>
    <li><strong>Data de Nascimento:</strong> ${record.data_nascimento_paciente}</li>
    <li><strong>Email:</strong> ${record.email_paciente}</li>
    <li><strong>Endereço:</strong> ${record.endereco_rua_paciente}, ${record.cidade_paciente} - ${record.estado_patiente}</li>
  `;
  div.appendChild(patientDataList);

  const doctorDataHeading = document.createElement('h2');
  doctorDataHeading.textContent = 'Dados do Médico';
  div.appendChild(doctorDataHeading);

  const doctorDataList = document.createElement('ul');
  doctorDataList.innerHTML = `
    <li><strong>Nome:</strong> ${record.doctor.nome_medico}</li>
    <li><strong>CRM:</strong> ${record.doctor.crm_medico} (${record.doctor.crm_medico_estado})</li>
    <li><strong>Email:</strong> ${record.doctor.email_medico}</li>
  `;
  div.appendChild(doctorDataList);

  const testResultsHeading = document.createElement('h2');
  testResultsHeading.textContent = 'Resultados dos Exames';
  div.appendChild(testResultsHeading);

  const testResultsTable = document.createElement('table');
  const tableHeader = document.createElement('thead');
  tableHeader.innerHTML = `
    <tr>
      <th>Tipo de Exame</th>
      <th>Limites</th>
      <th>Resultado</th>
    </tr>
  `;
  testResultsTable.appendChild(tableHeader);

  const tableBody = document.createElement('tbody');
  tableBody.innerHTML = record.tests.map((test) => `
    <tr>
      <td>${test.tipo_exame}</td>
      <td>${test.limites_tipo_exame}</td>
      <td>${test.resultado_tipo_exame}</td>
    </tr>
  `).join('');
  testResultsTable.appendChild(tableBody);

  div.appendChild(testResultsTable);

  return div;
}

const styleContent = `
  body {
    font-family: sans-serif;
    background-color: #f0f0f0;
  }

  .card {
    background-color: #ffffff;
    max-width: 500px;
    margin: auto;
    padding: 20px;
    margin-bottom: 20px;
    box-shadow: 0 4px 8px 0 rgba(0,0,0,0.2);
    transition: 0.3s;
    border-radius: 5px;
  }

  .card:hover {
    box-shadow: 0 8px 16px 0 rgba(0,0,0,0.2);
  }

  table {
    width: 100%;
    border-collapse: collapse;
  }

  th, td {
    border-bottom: 1px solid #ddd;
    padding: 6px;
    text-align: left;
  }

  th {
    background-color: #f4f4f4;
  }

  td {
    font-weight: bold;
  }

  h1 {
    text-align: center;
    margin-top: 40px;
  }

  form {
    text-align: center;
    margin: 0 auto;
    max-width: 300px;
    padding: 20px;
    border: 1px solid #ccc;
    border-radius: 5px;
    background-color: #f9f9f9;
    margin-bottom: 15px;
  }

  label {
    display: block;
    margin-bottom: 10px;
    font-weight: bold;
  }

  input[type="file"] {
    display: block;
    margin: 0 auto 10px auto;
  }
`;

const styleElement = document.createElement('style');
styleElement.textContent = styleContent;
document.head.appendChild(styleElement);

fetchAndRenderData();