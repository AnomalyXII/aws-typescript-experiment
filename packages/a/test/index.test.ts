import {expect} from 'chai';
import HelloWorld from "../src";


test('says "Hello World"', () => {
    const hello = new HelloWorld();
    expect(hello.get_hello()).to.equal('Hello World');
});
