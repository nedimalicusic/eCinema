using eCinema.Core;
using FluentValidation;

namespace eCinema.Application
{
    public class ReservationValidator : AbstractValidator<ReservationUpsertDto>
    {
        public ReservationValidator()
        {
            RuleFor(c => c.isActive).NotNull().WithErrorCode(ErrorCodes.NotNull);
            RuleFor(c => c.IsClosed).NotNull().WithErrorCode(ErrorCodes.NotNull);
            RuleFor(c => c.ShowSeatId).NotNull().WithErrorCode(ErrorCodes.NotNull);
            RuleFor(c => c.UserId).NotNull().WithErrorCode(ErrorCodes.NotNull);
        }
    }
}
