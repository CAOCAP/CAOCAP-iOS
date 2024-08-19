function transpileAndGenerate(code) {
    return Babel.transform(code, { presets: ['env'] }).code;
}

const inputCode = "const arrowFunc = () => console.log('Hello, Babel!');";
console.log("Input:", inputCode);
console.log("Output:", transpileAndGenerate(inputCode));
