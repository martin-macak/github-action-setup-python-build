from example.hello import greeting


def test_example():
    got = greeting()
    assert got == "Hello World!"
