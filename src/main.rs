fn main() {
    let message = hex::FromHexError::OddLength.to_string();
    assert_eq!(message, "Odd number of hex digits");
    println!("{message}");
}
