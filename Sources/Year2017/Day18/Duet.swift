// Assembly code written on a tablet.
public class Duet {
    // Syntaxic sugar for register names.
    public typealias Register = Character
    
    // Run both given processor until both are stop or a deadlock happen.  Before
    // they are run, the processors are setup to communicate with each other:
    // that is when p0 (or p1) send a message, p1 (respectively p0) is notified.
    // If a callback was already setup for the .send event it will still be
    // called.
    public static func run_in_duet(_ p0: Processor, and p1: Processor) {
        // Install a dummy callback for the .send event just so that we can
        // retrieve the current one (if any).
        let noop: Processor.Callback = { _ in .proceed }
        let maybe_p0_on_send = p0.on(.send, callback: noop)
        let maybe_p1_on_send = p1.on(.send, callback: noop)
        // Bind to the .send event to notifiy the other processor, "wrapping" the
        // callback previously installed. NOTE: a retain cycle is created here.
        p0.on(.send) {
            p1.notify(msg: $0!)
            guard let p0_on_send = maybe_p0_on_send else { return .proceed }
            return p0_on_send($0)
        }
        p1.on(.send) {
            p0.notify(msg: $0!)
            guard let p1_on_send = maybe_p1_on_send else { return .proceed }
            return p1_on_send($0)
        }
        // Run both processor until they stop or we're in a deadlock situation
        // (i.e. both CPU are waiting)
        let both_stopped = { p0.is_stopped && p1.is_stopped }
        let deadlock     = { p0.is_waiting && p1.is_waiting }
        while !both_stopped() && !deadlock() {
            p0.run()
            p1.run()
        }
        // Restore the old .send callbacks (if any), breaking the retain cycle.
        p0.on(.send, callback: maybe_p0_on_send ?? noop)
        p1.on(.send, callback: maybe_p1_on_send ?? noop)
    }
}
