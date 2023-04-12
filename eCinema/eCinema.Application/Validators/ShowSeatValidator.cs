using eCinema.Core;
using FluentValidation;

namespace eCinema.Application
{
    public class ShowSeatValidator : AbstractValidator<ShowSeatUpsertDto>
    {
        public ShowSeatValidator()
        {
            RuleFor(c => c.isReserved).NotNull().WithErrorCode(ErrorCodes.NotNull);
            RuleFor(c => c.isSelected).NotNull().WithErrorCode(ErrorCodes.NotNull);
            RuleFor(c => c.isAvailable).NotNull().WithErrorCode(ErrorCodes.NotNull);
            RuleFor(c => c.ShowId).NotNull().WithErrorCode(ErrorCodes.NotNull);
            RuleFor(c => c.SeatId).NotNull().WithErrorCode(ErrorCodes.NotNull);
        }
    }
}
