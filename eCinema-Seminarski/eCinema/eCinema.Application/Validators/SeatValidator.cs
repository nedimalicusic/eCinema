using eCinema.Core;
using FluentValidation;

namespace eCinema.Application
{
    public class SeatValidator : AbstractValidator<SeatUpsertDto>
    {
        public SeatValidator()
        {
            RuleFor(c => c.Row).NotEmpty().WithErrorCode(ErrorCodes.NotEmpty);
            RuleFor(c => c.Column).NotNull().WithErrorCode(ErrorCodes.NotNull);
        }
    }
}
