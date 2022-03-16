module clock (
    output clock
);
    reg clock = 1;

    initial begin
        forever begin
            #10 clock = !clock;
        end
    end

endmodule