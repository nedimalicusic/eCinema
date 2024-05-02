using eCinema.Core;
using FluentValidation;

namespace eCinema.Application
{
    public class ReservationValidator : AbstractValidator<ReservationUpsertDto>
    {
        public ReservationValidator()
        {
            RuleFor(c => c.ShowId).NotNull().WithErrorCode(ErrorCodes.NotNull);
            RuleFor(c => c.SeatId).NotNull().WithErrorCode(ErrorCodes.NotNull);
            RuleFor(c => c.UserId).NotNull().WithErrorCode(ErrorCodes.NotNull);
        }
    }
}
