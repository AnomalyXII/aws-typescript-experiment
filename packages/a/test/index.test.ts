import HelloWorld from "../src/index";


test('says "Hello World"', () => {
    const hello = new HelloWorld();
    expect(hello.get_hello()).toEqual('Hello World');
});
