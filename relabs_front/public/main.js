const fragment = new DocumentFragment();
const url = 'http://localhost:3001/tests';

fetch(url).
  then((response) => response.json()).
  then((data) => {
    data.forEach(function(record) {
      const li = document.createElement('li');
      li.textContent = `${record.nome_paciente}`;
      fragment.appendChild(li);
    })
  }).
  then(() => {
    document.querySelector('ul').appendChild(fragment);
  }).
  catch((error) => {
    console.log(error);
  });
