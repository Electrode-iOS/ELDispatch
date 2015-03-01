# KillerRabbit
THGDispatch module, includes GCD bits such as Queues, Groups, Timer, Semaphore, etc.

Provides useful Swift language constructs to oft-used Grand Central Dispatch patterns

Grand Central Dispatch is a powerful framework, but it can easily be difficult for someone to grasp how to use it well. With Swift, we can provide language constructs such as enumerations to allow dispatching closures to various prenamed priorities, such as .Background. We can also make using GCD groups easier through function chaining.

___

## A quick word about dependencies

THGDispatch/KillerRabbit depends on THGFoundation/Excalibur (https://github.com/TheHolyGrail/Excalibur).  The projects are designed to live side-by-side in the file system.  ie:

* \MyProject
* \MyProject\Excalibur
* \MyProject\KillerRabbit

We use an experimental tool called Modulo for dependency management.  It doesn't require Xcode workspaces, mess with your project, or have arcane config files that break every release, it's simple JSON.  It also doesn't require your dependencies to use Modulo either.  If you're using Modulo, you can also link to an existing git repo that doesn't use Modulo, it doesn't care.

That being said.. you don't have to use Modulo!  You can simple add both of these github projects as submodules and it'll work just the same.

Now back to the good stuff....

## Introduction

THGDispatch/KillerRabbit was heavily influenced by John Estropia's GCDKit (https://github.com/JohnEstropia/GCDKit).  We love the work he's done, despite having taken a slightly different direction in syntax and implementation.

The following constructs have been implemented:

* `Dispatch`: An abstraction of the `dispatch_*` APIs.
* `DispatchQueue`: An abstraction of the `dispatc_queue_*` APIs.
* `DispatchClosure`: An abstraction of the `dispatch_block_*` APIs.
* `DispatchGroup`: An abstraction of the `dispatch_group_*` APIs.
* `DispatchTimer`: A struct implementing a GCD timer using the `dispatch_source_*` APIs.
* `DispatchSemaphore`: An abstraction of the `dispatch_semaphore_*` APIs.

## Common Usage

Executing a run-of-the-mill asynchronous closure:

```Swift
Dispatch().async(.Background) {
    doSomething()
}
```

Executing an asynchronous closure on a background queue and notifying the main thread when it's completed:
```Swift
Dispatch().async(.Background) {
    doSomething()
}.notify(.Main) {
    dearMainThreadImDone()
}
```

Executing an asychronous closure and waiting for 3 seconds:
```Swift
Dispatch().async(.Background) {
    doSomething()
}.wait(3) == false {
    itTimedOutImSad()
} else {
    itWasSuccessfulAndMyLifeHasMeaning()
}
```

Executing a few async tasks as a group and waiting indefinitely:
```Swift
DispatchGroup().async(.Background) {
    doSomething(1)
}.async(.Utility) {
    doSomething(2)
}.async(.High) {
    doSomethingUrgently(3)
}.wait()
```
or...
```Swift
let group = DispatchGroup()

group.async(.Background) {
    doSomething(1)
}.async(.Utility) {
    doSomething(2)
}.async(.High) {
    doSomethingUrgently(3)
}

if group.wait(10) == true {
    handstandAndCartwheel()
}
```

Execute an asynchronous task, synchronously with a Semaphore:
```Swift
let semaphore = DispatchSemaphore(initialValue: 0)
        
// start a NSURLSession to get some data from our imaginary command line tool.
let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
    if data != nil {
        let dataString: String = NSString(data: data, encoding: NSUTF8StringEncoding)! as String
        json = JSON(string: dataString)
    }
            
    semaphore.signal()
}
        
task.resume()
        
semaphore.wait()
```
## Contributions

We appreciate your contributions to all of our projects and look forward to interacting with you via Pull Requests, the issue tracker, via Twitter, etc.  We're happy to help you, and to have you help us.  We'll strive to answer every PR and issue and be very transparent in what we do.

###### THG's Primary Contributors

Dr. Sneed (@bsneed)<br>
Steve Riggins (@steveriggins)<br>
Sam Grover (@samgrover)<br>
Angelo Di Paolo (@angelodipaolo)<br>
Cody Garvin (@migs647)<br>
Wes Ostler (@wesostler)<br>

## License

The MIT License (MIT)

Copyright (c) 2015 Walmart, TheHolyGrail, and other Contributors

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
