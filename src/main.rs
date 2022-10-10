fn main() {
    let schema = r#"not valid"#;
    println!("{}", prisma_fmt::format(schema, "schema"));
}
