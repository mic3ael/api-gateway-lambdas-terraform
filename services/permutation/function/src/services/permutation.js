function swap(array, i, j) {
  const temp = array[i];
  array[i] = array[j];
  array[j] = temp;
}

function getPermutationsHelper(i, array, perms) {
  if (array.length - 1 === i) return perms.push(Array.from(array));

  for (let j = i; j < array.length; j++) {
    swap(array, i, j);
    getPermutationsHelper(i + 1, array, perms);
    swap(array, i, j);
  }
}

const actions = (_storage) => ({
  calc: (value) => {
    //TODO: cache from storage
    const perms = [];
    const parts = value.split('');
    getPermutationsHelper(0, parts, perms);
    //TODO: save in storage

    return perms;
  },
});

export default () => actions({});
